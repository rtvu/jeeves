//  Returns an array containing tags of renderable component objects that have
//  'value' property.
function getValueTags() {
  return ["server-path-selector", "text-selector", "textarea-selector"]
}
//  Local copy for module.
let valueTags = getValueTags()


//  Returns an array containing tags of component objects that have 'components'
//  property.
function getComponentsTags() {
  return ["components-selector", "optional-selector", "dependencies-selector"]
}
//  Local copy for module.
let componentsTags = getComponentsTags()


//  Makes a deep copy of 'item' object. Only JSON compliant properties are
//  copied.
function duplicateItem(item) {
  return JSON.parse(JSON.stringify(item))
}


//  'component' may be a deeply nested object.
//  'path' is an array of indices specifying the traversal through 'component'.
//  'value' is the value of the target property inside 'component'.
//
//  Traverses 'component' using indices provided by 'path' to set target
//  property to 'value'.
function setNestedComponentProperty(component, path, value) {
  for (let i = 0; i < path.length; i++) {
    component = component.components[path[i]]
  }
  component.value = value
}


//  User defined component(s) representation is different than the internal
//  component(s) representation.
//    - User defind:
//      - 'value' properties are optional.
//      - 'components' is defined with array.
//    - Internal
//      - Components may create non-rendered children components to manage
//        state.
//
//  Converts a user defined component object to internal component object
function formatComponent(object) {
  //  Add value property.
  if (valueTags.includes(object.tag)) {
    if (!object.hasOwnProperty("value")) {
      object.value = ""
    }
  }

  //  Handle 'components' property.
  //    - Format children components.
  //    - Convert 'components' array to 'components' object
  if (componentsTags.includes(object.tag)) {
    let newComponents = {}
    for (let i = 0; i < object.components.length; i++) {
      formatComponent(object.components[i])
      newComponents[i] = object.components[i]
    }
    newComponents.length = object.components.length
    object.components = newComponents
  }

  //  Handle special cases of 'component'
  formatComponentSpecialCases(object)
}
function formatComponentSpecialCases(object) {
  if (object.tag === "optional-selector") {
    object.components.optionalValue = {
      tag: "optional-value",
      model: "optional-value",
      value: object.selected
    }
  }
}


export {
  duplicateItem,
  setNestedComponentProperty,
  formatComponent
};
