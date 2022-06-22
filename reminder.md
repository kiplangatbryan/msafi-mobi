## lifecycle hooks

    
### createState() 
called when we create a stateful widget

### initState()
called before the widget is built

### didChangeDependencies()

called after initState

### build() 
used to rebder the widget on the screen

### didUpdateWidget()

called whenever the parent component changes

@protected
    void didUpdateWidget(Home oldWidget) {
    super.didUpdateWidget(oldWidget);
}

### setState()
 illuminates to the framework that the internal state of the app has changes which causes it to rerender the UI

### deactivate()

This strategy is considered when the widget is as of now not joined to the Widget Tree yet it very well may be appended in a later stage. The best illustration of this is the point at which you use Navigator. push to move to the following screen, deactivate is called because the client can move back to the past screen and the widget will again be added to the tree

@override
void deactivate(){
  super.deactivate();
}
### dispose()


This strategy is essentially something contrary to the initState() method and is likewise important. It is considered when the object and its State should be eliminated from the Widget Tree forever and won’t ever assemble again.

Here you can unsubscribe streams, cancel timers, dispose animations controllers, close documents, and so on. At the end of the day, you can deliver every one of the assets in this strategy. Presently, later on, if the Widget is again added to Widget Tree, the whole lifecycle will again be followed!.

@override
void dispose(){
  super.dispose();
}
