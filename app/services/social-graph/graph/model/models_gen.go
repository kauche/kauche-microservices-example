// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package model

type Comment struct {
	ID   string `json:"id"`
	Text string `json:"text"`
}

type Product struct {
	ID       string     `json:"id"`
	Comments []*Comment `json:"comments"`
}

func (Product) IsEntity() {}
