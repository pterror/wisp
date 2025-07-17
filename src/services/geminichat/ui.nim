# See https://github.com/ire4ever1190/tree/blob/98a19dc371cc54f87a530097995c55a79ae8b263/examples/overview.nim#L13
import tree
import ../../ext/tree/optics

proc TodosForm(list: Lens[seq[cstring]]): Element {.used.} =
  let value = createLens[cstring]()

  gui:
    form:
      proc submit(event: Event) =
        event.preventDefault
        list.set(list.get() & value.get())
        value.clear

      tdiv:
        StringInput(value)
        button(`type` = "submit"):
          "Add"

proc Todos(): Element =
  let list = createLens[seq[cstring]]()

  gui:
    fieldset:
      legend:
        "Todos"
      TodosForm(list)
      ul(class = "todos"):
        for i, item in list.get():
          li:
            text(item)
            proc click() =
              var items = list.get()
              items.delete(i)
              list.set(items)

Todos.renderTo("root")
