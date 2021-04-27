# README

## Graph AllPaths going nuts

There is a problem that appears when you have a lot of tables (> 20 +-) with references to other tables.

When you send a query that relates to other tables, the process never ends the graph traverse, crashing the server.

To visualize the problem (and prevent crashing :-)) you have change graphjin:

```go
// core/internal/util/graph.go:54
func (g *Graph) AllPaths(from, to int32) [][]int32 {
	log.Printf("from: %d to: %d\n", from, to)
	limit := 0
	var paths [][]int32

	h := newHeap()
	h.push(path{weight: 0, nodes: []int32{from}})
	visited := make(map[[2]int32]struct{})

	for len(*h.paths) > 0 {
		limit++
		if limit > 3000 {
			log.Println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! bail out, bye !!!!!!!!!!!!!!!!!!!!!!!!!")
			return paths
		}
		// Find the nearest unvisited node
		p := h.pop()
		node := p.nodes[len(p.nodes)-1]
		log.Printf("node: %d parent: %d len_nodes: %d len_visited: %d\n", node, p.parent, len(p.nodes), len(p.visited))

		if _, ok := visited[[2]int32{p.parent, node}]; ok {
			log.Printf("visited node: %d\n", node)
			continue
		}

		if node == to && len(p.nodes) > 1 {
			log.Printf("append %d nodes\n", len(p.nodes))
			paths = append(paths, p.nodes)
			continue
		}

		for _, e := range g.graph[node] {
			if _, ok := p.visited[e]; ok && e != to {
				log.Printf("visited e: %d\n", e)
				continue
			}

			if _, ok := visited[[2]int32{node, e}]; !ok {
				// We calculate cost so far and add in the weight (cost) of this edge.
				p1 := path{
					weight:  p.weight + 1,
					parent:  node,
					nodes:   append(append([]int32{}, p.nodes...), e),
					visited: make(map[int32]struct{}),
				}
				for _, v := range p1.nodes {
					p1.visited[v] = struct{}{}
				}
				h.push(p1)
				log.Printf("weight: %d parent: %d len_nodes: %d len_visited: %d\n", p1.weight, p.parent, len(p1.nodes), len(p1.visited))
			}
		}
	}

	return paths
}
```

Basically it prints part of the traverse and also bails out with a hard limit of 3000.

Beyond solving this particular issue, I think that is a good idea to always have a hard limit, that logs the issue as a warning, and prevents crashing just in case.

To view the problem:

```sh
# graphjin must be in the path, compiled with the above change
# don't run without the bail out change, it crash the machine
make run
```

> It could take 2-4 minutes to finish the initial traversal.

You could send this query:

```gql
query getUser {
  users(order_by: {created_at: desc}, limit: 10) {
    ...User
  }
}

fragment User on users {
  id
  email
  full_name
  created_at
  category_counts {
    category {
      id
      name
    }
    count
  }
}
```

It's going to bail out.

```sh
...
2021/04/27 12:17:39 node: 18 parent: 15 len_nodes: 7 len_visited: 7
2021/04/27 12:17:39 visited e: 2
2021/04/27 12:17:39 visited e: 15
2021/04/27 12:17:39 visited e: 12
2021/04/27 12:17:39 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! bail out, bye !!!!!!!!!!!!!!!!!!!!!!!!!
INFO	Query	{"op": "QTQuery", "name": "getUser", "role": "anon", "sql": "/* action='getUser',controller='graphql',framework='graphjin' */ SELECT jsonb_build_object('users', __sj_0.json) AS __root FROM ((SELECT true)) AS __root_x LEFT OUTER JOIN LATERAL (SELECT COALESCE(jsonb_agg(__sj_0.json), '[]') AS json FROM (SELECT to_jsonb(__sr_0.*) AS json FROM (SELECT users_0.id AS \"id\", users_0.email AS \"email\", users_0.full_name AS \"full_name\", users_0.created_at AS \"created_at\", __sj_1.json AS \"category_counts\" FROM (SELECT \"users\".id, \"users\".email, \"users\".full_name, \"users\".created_at FROM \"users\" ORDER BY \"users\".created_at DESC LIMIT 10) AS users_0 LEFT OUTER JOIN LATERAL (SELECT COALESCE(jsonb_agg(__sj_1.json), '[]') AS json FROM (SELECT to_jsonb(__sr_1.*) AS json FROM (SELECT category_counts_1.count AS \"count\", __sj_2.json AS \"category\" FROM (SELECT \"category_counts\".count, \"category_counts\".category_id FROM users, jsonb_to_recordset(\"users\".category_counts) AS \"category_counts\"(category_id bigint, count integer) WHERE ((\"users\".id) = (users_0.id)) LIMIT 20) AS category_counts_1 LEFT OUTER JOIN LATERAL (SELECT to_jsonb(__sr_2.*) AS json FROM (SELECT categories_2.id AS \"id\", categories_2.name AS \"name\" FROM (SELECT \"categories\".id, \"categories\".name FROM \"categories\" WHERE ((\"categories\".id) = (category_counts_1.category_id)) LIMIT 1) AS categories_2) AS __sr_2) AS __sj_2 ON true) AS __sr_1) AS __sj_1) AS __sj_1 ON true) AS __sr_0) AS __sj_0) AS __sj_0 ON true"}
```

Also this sequence of queries triggers the issue:


```gql
mutation createProduct {
  products(insert: $data) {
    id
    name
    description
    category_ids
  }
}
{
  "data": {
    "name": "New Created Product 01",
    "description": "Very Nice Product, Specially design for you",
    "category_ids": [1,2],
    "created_at": "now",
    "updated_at": "now",
    "user": {
      "connect": {
        "id": 1
      }
    }
  }
}

mutation createTimedCommentForProduct {
  timed_comments(insert: $data) {
    id
    products {
      id
      name
    }
  }
}
{
  "data": {
    "ts": "now",
    "body": "timed comment example number 01",
    "created_at": "now",
    "updated_at": "now",
    "product": {
      "connect": {
        "name": "New Created Product 01"
      }
    }
  }
}

query getProductTimedComments {
  timed_comments(
    last: $last
    before: $cursor
    where: { products: { name: { eq: $name } } }
  ) {
    ...productTimedCommentFields
  }
}
fragment productTimedCommentFields on timed_comments {
  ts
  id
  body
  user_id
  product_id
  __typename
}
{
  "last": 20,
  "name": "New Created Product 01",
  "cursor": null
}
```
