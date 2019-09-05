// function getValueTags() {
//   return ["server-file-selector", "text-selector", "textarea-selector", "optional-value"]
// }


function getValueTags() {
  return ["server-file-selector", "text-selector", "textarea-selector"]
}


function addOptionalValueComponent(components) {
  let valueTags = getValueTags()

  for (let component of components) {
    if (!valueTags.includes(component.tag)) {
      if (component.tag === "optional-selector") {
        component.components.unshift({
          tag: "optional-value",
          model: "optional-value",
          value: component.selected
        })
      }
      addOptionalValueComponent(component.components)
    }
  }
}

function addValueProperty(components) {
  let valueTags = getValueTags()

  for (let component of components) {
    if (valueTags.includes(component.tag)) {
      if(!component.hasOwnProperty("value")) {
        component.value = ""
      }
    } else {
      addValueProperty(component.components)
    }
  }
}

function duplicateItem(item) {
  return JSON.parse(JSON.stringify(item))
}

function setNestedComponentProperty(component, path, value) {
  for (let i = 0; i < path.length; i++) {
    component = component.components[path[i]]
  }
  component.value = value

  //
  // let internalPath = duplicateItem(path)
  //
  // if (internalPath.length !== 0) {
  //   let key = internalPath.pop()
  //
  //   for (let component of components) {
  //     if (component.model === model) {
  //       if (internalPath.length === 0) {
  //         component.value = value
  //         break
  //       } else {
  //         setNestedComponentProperty(component.components, internalPath, value)
  //       }
  //     }
  //   }
  // }
}


// Convert component specification to object
function formatComponent(specification) {
  let valueTags = getValueTags()
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
  addOptionalValueComponent,
  addValueProperty,
  duplicateItem,
  setNestedComponentProperty,
  formatComponent
};
