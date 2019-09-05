function getValueTags() {
  return ["server-file-selector", "text-selector", "textarea-selector"]
}
let valueTags = getValueTags()


function duplicateItem(item) {
  return JSON.parse(JSON.stringify(item))
}


function setNestedComponentProperty(component, path, value) {
  for (let i = 0; i < path.length; i++) {
    component = component.components[path[i]]
  }
  component.value = value
}

// Convert component specification to object
function formatComponent(specification) {
  if (valueTags.includes(specification.tag)) {
    if (!specification.hasOwnProperty("value")) {
      specification.value = ""
    }
  } else {
    let newComponents = {}
    for (let i = 0; i < specification.components.length; i++) {
      formatComponent(specification.components[i])
      newComponents[i] = specification.components[i]
    }
    newComponents.length = specification.components.length
    specification.components = newComponents
  }
  formatComponentSpecialCases(specification)
}
function formatComponentSpecialCases(specification) {
  if (specification.tag === "optional-selector") {
    specification.components.optionalSelector = {
      tag: "optional-value",
      model: "optional-value",
      value: specification.selected
    }
  }
}

export {
  getValueTags,
  duplicateItem,
  setNestedComponentProperty,
  formatComponent
};
