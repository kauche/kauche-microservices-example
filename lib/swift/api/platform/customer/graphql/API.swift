// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class ProductListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ProductList {
      products {
        __typename
        id
        name
        comments {
          __typename
          id
          text
          customer {
            __typename
            id
            name
          }
        }
      }
    }
    """

  public let operationName: String = "ProductList"

  public let operationIdentifier: String? = "bb453e2dabbe49a2c3be87caaab14b00bd7b844377199f2d4dd303eb5a792925"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("products", type: .nonNull(.list(.nonNull(.object(Product.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(products: [Product]) {
      self.init(unsafeResultMap: ["__typename": "Query", "products": products.map { (value: Product) -> ResultMap in value.resultMap }])
    }

    public var products: [Product] {
      get {
        return (resultMap["products"] as! [ResultMap]).map { (value: ResultMap) -> Product in Product(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Product) -> ResultMap in value.resultMap }, forKey: "products")
      }
    }

    public struct Product: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Product"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("comments", type: .nonNull(.list(.nonNull(.object(Comment.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, comments: [Comment]) {
        self.init(unsafeResultMap: ["__typename": "Product", "id": id, "name": name, "comments": comments.map { (value: Comment) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var comments: [Comment] {
        get {
          return (resultMap["comments"] as! [ResultMap]).map { (value: ResultMap) -> Comment in Comment(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Comment) -> ResultMap in value.resultMap }, forKey: "comments")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Comment"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("text", type: .nonNull(.scalar(String.self))),
            GraphQLField("customer", type: .nonNull(.object(Customer.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, text: String, customer: Customer) {
          self.init(unsafeResultMap: ["__typename": "Comment", "id": id, "text": text, "customer": customer.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var text: String {
          get {
            return resultMap["text"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "text")
          }
        }

        public var customer: Customer {
          get {
            return Customer(unsafeResultMap: resultMap["customer"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "customer")
          }
        }

        public struct Customer: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Customer"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String) {
            self.init(unsafeResultMap: ["__typename": "Customer", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}
