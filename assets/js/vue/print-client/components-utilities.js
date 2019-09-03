function getValueTags() {
  return ["server-file-selector", "text-selector", "textarea-selector"];
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

function setNestedComponentProperty(components, path, value) {
  let internalPath = duplicateItem(path)

  if (internalPath.length !== 0) {
    let model = internalPath.shift()

    for (let component of components) {
      if (component.model === model) {
        if (internalPath.length === 0) {
          component.value = value
          break
        } else {
          setNestedComponentProperty(component.components, internalPath, value)
        }
      }
    }
  }
}

// function validComponents(components, model = []) {
//   let componentLiterals = getComponentLiterals()
//
//   for (let component of components) {
//     if (componentLiterals.includes(component.tag)) {
//       // Handle component literals case
//       if (!model.includes(component.model)) {
//         // Handle when model is unique
//         model.push(component.model)
//       } else {
//         // Handle when model is repeated
//         return false
//       }
//     } else {
//       // Handle nested components
//       if (!validComponents(component.components, model)) {
//         return false
//       }
//     }
//   }
//
//   return true
// }

export {
  getValueTags,
  addValueProperty,
  duplicateItem,
  setNestedComponentProperty
};
