--# assume global class LOG
--# assume global class BUTTON
--# assume global class TEXT
--# assume global class IMAGE
--# assume global class TEXT_BUTTON
--# assume global class FRAME
--# assume global class TEXT_BOX
--# assume global class LIST_VIEW
--# assume global class DUMMY
--# assume global class UTIL
--# assume global class COMPONENTS
--# assume global class COLOURED_TEXT_BUTTON

--# type global COMPONENT_TYPE = 
--# TEXT | IMAGE | BUTTON | TEXT_BUTTON | FRAME | TEXT_BOX | LIST_VIEW | DUMMY | COLOURED_TEXT_BUTTON

--# type global BUTTON_TYPE = 
--# "CIRCULAR" | "SQUARE" | "CIRCULAR_TOGGLE" | "SQUARE_TOGGLE"

--# type global TEXT_BUTTON_TYPE = 
--# "TEXT" | "TEXT_TOGGLE" | "TEXT_TOGGLE_SMALL"

--# type global TEXT_TYPE = 
--# "NORMAL" | "WRAPPED" | "TITLE" | "HEADER"


--# assume global class CONTAINER
--# assume global class GAP
--# assume global class FLOW_LAYOUT

--# type global LAYOUT = FLOW_LAYOUT

--# type global FLOW_LAYOUT_TYPE = "VERTICAL" | "HORIZONTAL"

--# type global LIST_SCROLL_DIRECTION = "VERTICAL" | "HORIZONTAL"

--# assume global Log: LOG
--# assume global Text: TEXT
--# assume global Image: IMAGE
--# assume global Button: BUTTON
--# assume global TextButton: TEXT_BUTTON
--# assume global Frame: FRAME
--# assume global TextBox: TEXT_BOX
--# assume global ListView: LIST_VIEW
--# assume global Util: UTIL
--# assume global FlowLayout: FLOW_LAYOUT
--# assume global Dummy: DUMMY
--# assume global Container: CONTAINER

--# assume global TABLES: map<string, map<string, WHATEVER>>
--# assume global write_log: boolean

--# assume LOG.write: function(str: string)

--object creation functions
--# assume BUTTON.new: function(name: string, parent: CA_UIC | COMPONENT_TYPE, form: BUTTON_TYPE, imagePath: string) --> BUTTON
--# assume TEXT_BUTTON.new: function(name: string, parent: CA_UIC | COMPONENT_TYPE, form: TEXT_BUTTON_TYPE, text: string) --> TEXT_BUTTON
--# assume FRAME.new: function(name: string) --> FRAME
--# assume IMAGE.new: function(name: string, parent: CA_UIC | COMPONENT_TYPE, imagepath: string) --> IMAGE
--# assume TEXT.new: function(name: string, parent: CA_UIC | COMPONENT_TYPE, form: TEXT_TYPE, text: string) --> TEXT
--# assume LIST_VIEW.new: function(name: string, parent: CA_UIC | COMPONENT_TYPE, scroll:LIST_SCROLL_DIRECTION) --> LIST_VIEW
--# assume FLOW_LAYOUT.VERTICAL: FLOW_LAYOUT
--# assume FLOW_LAYOUT.HORIZONTAL: FLOW_LAYOUT
--# assume CONTAINER.new: function(layout: LAYOUT) --> CONTAINER
--# assume TEXT_BOX.new: function(name: string, parent: CA_UIC | COMPONENT_TYPE) --> TEXT_BOX

--utility
--# assume UTIL.getComponentWithName: function(name: string) --> COMPONENT_TYPE
--# assume UTIL.centreComponentOnScreen: function(component: CA_UIC | COMPONENT_TYPE | CONTAINER)
--# assume UTIL.centreComponentOnComponent: function(component: CA_UIC | COMPONENT_TYPE | CONTAINER, other_component: CA_UIC | COMPONENT_TYPE | CONTAINER)    
--# assume UTIL.recurseThroughChildrenApplyingFunction: function(parent: CA_UIC, callback:function(child: CA_UIC))

--button
--# assume BUTTON.MoveTo: method(xPos: number, yPos: number)
--# assume BUTTON.Move: method(XMove: number, yMove: number)
--# assume BUTTON.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume BUTTON.Scale: method(factor:number)
--# assume BUTTON.Resize: method(width: number, height: number)
--# assume BUTTON.SetVisible: method(visible: boolean)
--# assume BUTTON.Visible: method() --> boolean
--# assume BUTTON.Position: method() --> (number, number)
--# assume BUTTON.Bounds: method() --> (number, number)
--# assume BUTTON.Width: method() --> number
--# assume BUTTON.Height: method() --> number
--# assume BUTTON.GetContentComponent: method() --> CA_UIC
--# assume BUTTON.GetPositioningComponent: method() --> CA_UIC
--# assume BUTTON.Delete: method()
--# assume BUTTON.ClearSound: method()
--# assume BUTTON.SetState: method(state: BUTTON_STATE)
--# assume BUTTON.CurrentState: method() --> string
--# assume BUTTON.IsSelected: method() --> boolean
--# assume BUTTON.RegisterForClick: method(callback: function(context: WHATEVER?))
--# assume BUTTON.SetImage: method(path: string)
--# assume BUTTON.SetDisabled: method(disabled: boolean)
--# assume BUTTON.XPos: method() --> number
--# assume BUTTON.YPos: method() --> number

--text button
--# assume TEXT_BUTTON.MoveTo: method(xPos: number, yPos: number)
--# assume TEXT_BUTTON.Move: method(XMove: number, yMove: number)
--# assume TEXT_BUTTON.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume TEXT_BUTTON.Scale: method(factor:number)
--# assume TEXT_BUTTON.Resize: method(width: number, height: number)
--# assume TEXT_BUTTON.SetVisible: method(visible: boolean)
--# assume TEXT_BUTTON.Visible: method() --> boolean
--# assume TEXT_BUTTON.Position: method() --> (number, number)
--# assume TEXT_BUTTON.Bounds: method() --> (number, number)
--# assume TEXT_BUTTON.RegisterForClick: method(callback: function(context: WHATEVER?))
--# assume TEXT_BUTTON.SetDisabled: method(disabled: boolean)
--# assume TEXT_BUTTON.GetContentComponent: method() --> CA_UIC
--# assume TEXT_BUTTON.SetState: method(state: BUTTON_STATE)
--# assume TEXT_BUTTON.Width: method() --> number
--# assume TEXT_BUTTON.Height: method() --> number
--# assume TEXT_BUTTON.XPos: method() --> number
--# assume TEXT_BUTTON.YPos: method() --> number
--# assume TEXT_BUTTON.Delete: method()
--# assume TEXT_BUTTON.SetButtonText: method(text: string) 

--text box
--# assume TEXT_BOX.MoveTo: method(xPos: number, yPos: number)
--# assume TEXT_BOX.Move: method(XMove: number, yMove: number)
--# assume TEXT_BOX.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume TEXT_BOX.Scale: method(factor:number)
--# assume TEXT_BOX.Resize: method(width: number, height: number)
--# assume TEXT_BOX.SetVisible: method(visible: boolean)
--# assume TEXT_BOX.Visible: method() --> boolean
--# assume TEXT_BOX.Position: method() --> (number, number)
--# assume TEXT_BOX.Bounds: method() --> (number, number)
--# assume TEXT_BOX.GetContentComponent: method() --> CA_UIC
--# assume TEXT_BOX.GetPositioningComponent: method() --> CA_UIC
--# assume TEXT_BOX.Width: method() --> number
--# assume TEXT_BOX.Height: method() --> number
--# assume TEXT_BOX.XPos: method() --> number
--# assume TEXT_BOX.YPos: method() --> number
--# assume TEXT_BOX.Delete: method()
--# assume TEXT_BOX.GetText: method() --> string

--frame
--# assume FRAME.MoveTo: method(xPos: number, yPos: number)
--# assume FRAME.Move: method(xMove: number, yMove: number)
--# assume FRAME.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume FRAME.Scale: method(factor: number)
--# assume FRAME.Position: method() --> (number, number)
--# assume FRAME.Resize: method(number, number)
--# assume FRAME.Bounds: method() --> (number, number)
--# assume FRAME.XPos: method() --> number
--# assume FRAME.YPos: method() --> number
--# assume FRAME.Width: method() --> number
--# assume FRAME.Height: method() --> number
--# assume FRAME.SetVisible: method(visible: boolean)
--# assume FRAME.Visible: method() --> boolean
--# assume FRAME.GetContentComponent: method() --> CA_UIC
--# assume FRAME.GetPositioningComponent: method() --> CA_UIC
--# assume FRAME.Delete: method()
--# assume FRAME.AddComponent: method(component: CA_UIC | COMPONENT_TYPE | CONTAINER)
--# assume FRAME.SetTitle: method(title: string)
--# assume FRAME.AddCloseButton: method(callback: function, cross: bool?)
--# assume FRAME.GetContentPanel: method() --> CA_UIC
--# assume FRAME.uic: CA_UIC

--image
--# assume IMAGE.Resize: method(width: number, height: number)
--# assume IMAGE.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume IMAGE.Scale: method(factor: number)
--# assume IMAGE.Move: method(xMove: number, yMove: number)
--# assume IMAGE.SetImage: method(path: string)
--# assume IMAGE.GetContentComponent: method() --> CA_UIC
--# assume IMAGE.SetVisible: method(boolean)
--# assume IMAGE.Delete: method()
--text
--# assume TEXT.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume TEXT.GetContentComponent: method() --> CA_UIC
--# assume TEXT.SetText: method(str: string)
--# assume TEXT.Bounds: method() --> (number, number)
--# assume TEXT.Resize: method(x: number, y: number)
--# assume TEXT.SetVisible: method(visible: boolean)
--# assume TEXT.Delete: method()
--# assume TEXT.Position: method() --> (number, number)
--# assume TEXT.MoveTo: method(xPos: number, yPos: number)
--# assume TEXT.Width: method() --> number
--# assume TEXT.Height: method() --> number

--container
--# assume CONTAINER.AddComponent: method(component: CA_UIC | COMPONENT_TYPE | CONTAINER)
--# assume CONTAINER.GetContentComponent: method() --> CA_UIC
--# assume CONTAINER.AddGap: method(num: number)
--# assume CONTAINER.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume CONTAINER.MoveTo: method(x: number, y: number)
--# assume CONTAINER.Bounds: method() --> (number, number)
--# assume CONTAINER.RecursiveRetrieveAllComponents: method() --> vector<CA_UIC | COMPONENT_TYPE>
--# assume CONTAINER.Reposition: method()

--listview
--# assume LIST_VIEW.AddComponent: method(component: CA_UIC | COMPONENT_TYPE | CONTAINER)
--# assume LIST_VIEW.AddContainer: method(container: CONTAINER)
--# assume LIST_VIEW.Bounds: method() --> (number, number)
--# assume LIST_VIEW.Scale: method(factor: number)
--# assume LIST_VIEW.Resize: method(x: number, y: number)
--# assume LIST_VIEW.Delete: method()
--# assume LIST_VIEW.PositionRelativeTo: method(component: CA_UIC | COMPONENT_TYPE, xDiff: number, yDiff: number)
--# assume LIST_VIEW.MoveTo: method(x: number, y:number)
--# assume LIST_VIEW.Move: method(xMove: number, yMove: number)
--# assume LIST_VIEW.Position: method() --> (number, number)
--# assume LIST_VIEW.Width: method() --> number
--# assume LIST_VIEW.Height: method() --> number

--sm0kin
--# assume TEXT.uic: CA_UIC
--# assume IMAGE.uic: CA_UIC
--# assume BUTTON.uic: CA_UIC
--# assume TEXT_BUTTON.uic: CA_UIC
--# assume LIST_VIEW.uic: CA_UIC
--# assume COMPONENTS.uic: CA_UIC
--# assume TEXT_BOX.uic: CA_UIC

--# assume FRAME.name: string
--# assume TEXT.name: string
--# assume IMAGE.name: string
--# assume BUTTON.name: string
--# assume TEXT_BUTTON.name: string

--# assume UTIL.delete: function(uic: CA_UIC)
--# assume UTIL.registerComponent: function(component_name: string, component: COMPONENT_TYPE)
--# assume UTIL.unregisterComponent: function(component_name: string)
--# assume CONTAINER.Clear: method()
--# assume CONTAINER.SetVisible: method(visible: boolean)
--# assume UTIL.createComponent: function(component: string, parent: CA_UIC, template_path: string) --> CA_UIC
--# assume UTIL.registerForClick: function(component: CA_UIC, listener_name: string, callback: function(context: WHATEVER?))