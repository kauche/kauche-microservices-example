//
// AUTO-GENERATED FILE. DO NOT MODIFY.
//
// This class was automatically generated by Apollo GraphQL version '3.8.2'.
//
package com.kauche.api.platform.customer.graphql

import com.apollographql.apollo3.annotations.ApolloAdaptableWith
import com.apollographql.apollo3.api.Adapter
import com.apollographql.apollo3.api.CompiledField
import com.apollographql.apollo3.api.CustomScalarAdapters
import com.apollographql.apollo3.api.Query
import com.apollographql.apollo3.api.json.JsonWriter
import com.apollographql.apollo3.api.obj
import com.kauche.api.platform.customer.graphql.adapter.ProductListQuery_ResponseAdapter
import com.kauche.api.platform.customer.graphql.selections.ProductListQuerySelections
import kotlin.Any
import kotlin.Boolean
import kotlin.Int
import kotlin.String
import kotlin.Unit
import kotlin.collections.List

public class ProductListQuery() : Query<ProductListQuery.Data> {
  public override fun equals(other: Any?): Boolean = other != null && other::class == this::class

  public override fun hashCode(): Int = this::class.hashCode()

  public override fun id(): String = OPERATION_ID

  public override fun document(): String = OPERATION_DOCUMENT

  public override fun name(): String = OPERATION_NAME

  public override fun serializeVariables(writer: JsonWriter,
      customScalarAdapters: CustomScalarAdapters): Unit {
    // This operation doesn't have any variable
  }

  public override fun adapter(): Adapter<Data> = ProductListQuery_ResponseAdapter.Data.obj()

  public override fun rootField(): CompiledField = CompiledField.Builder(
    name = "data",
    type = com.kauche.api.platform.customer.graphql.type.Query.type
  )
  .selections(selections = ProductListQuerySelections.__root)
  .build()

  @ApolloAdaptableWith(ProductListQuery_ResponseAdapter.Data::class)
  public data class Data(
    public val products: List<Product>,
  ) : Query.Data

  public data class Product(
    public val id: String,
    public val name: String,
    public val comments: List<Comment>,
  )

  public data class Comment(
    public val id: String,
    public val text: String,
    public val customer: Customer,
  )

  public data class Customer(
    public val id: String,
    public val name: String,
  )

  public companion object {
    public const val OPERATION_ID: String =
        "7a9705bd2db1afc6ffa7f692ce27e4f4a87ed213b563cda6963d0b3e777d2866"

    /**
     * The minimized GraphQL document being sent to the server to save a few bytes.
     * The un-minimized version is:
     *
     * query ProductList {
     *   products {
     *     id
     *     name
     *     comments {
     *       id
     *       text
     *       customer {
     *         id
     *         name
     *       }
     *     }
     *   }
     * }
     */
    public val OPERATION_DOCUMENT: String
      get() = "query ProductList { products { id name comments { id text customer { id name } } } }"

    public const val OPERATION_NAME: String = "ProductList"
  }
}
