#############################################################################
##
#W  canvas.gi                   FRANCY library                 Manuel Martins
##
#Y  Copyright (C) 2017 Manuel Martins
##

#############################################################################
##
#M  CanvasDefaults . . . . . . . . . .  the various properties for a canvas
##
BindGlobal("CanvasDefaults", Objectify(NewType(CanvasFamily, IsCanvasDefaults and IsCanvasDefaultsRep), rec(
  w:= "100%",
  h:= "600"
)));

#############################################################################
##
#M  Canvas( <title>, <options> ) . . . . . a new graphic canvas
##
InstallMethod(Canvas,
  "a title string, a default configurations record",
  true,
  [IsString,
   IsCanvasDefaults],
  0,
function(title, options)
  return MergeObjects(Objectify(NewType(CanvasFamily, IsCanvas and IsCanvasRep), rec(
    id        := HexStringUUID(RandomUUID()),
    menus     := rec(),
    graph    := rec(),
    chart    := rec(),
    title     := title
  )), options);
end);

InstallOtherMethod(Canvas,
  "a title string",
  true,
  [IsString],
  0,
function(title)
  return Canvas(title, CanvasDefaults);
end);

#############################################################################
##
#M  Add( <canvas>, <francy object> ) . . . . . add objects to canvas
##
InstallMethod(Add,
  "a canvas, a shape",
  true,
  [IsCanvas,
   IsFrancyObject],
  0,
function(canvas, object)
  if IsGraph(object) then
    canvas!.graph := object;
  elif IsChart(object) then
    canvas!.chart := object;
  elif IsMenu(object) then
    canvas!.menus!.(object!.id) := object;
  fi;
  return canvas;
end);

InstallOtherMethod(Add,
  "a canvas, a list of francy objects",
  true,
  [IsCanvas,
   IsList],
  0,
function(canvas, objects)
  local object;
  for object in objects do
    Add(canvas, object);
  od;
  return canvas;
end);

#############################################################################
##
#M  Remove( <canvas>, <francy object> ) . . . . . remove object from canvas
##
InstallMethod(Remove,
  "a canvas, a shape",
  true,
  [IsCanvas,
   IsFrancyObject],
  0,
function(canvas, object)
  local link;
  if IsGraph(object) then
    Unbind(canvas!.graph);
  elif IsChart(object) then
    Unbind(canvas!.chart);
  elif IsMenu(object) then
    Unbind(canvas!.menus!.(object!.id));
  fi;
  return canvas;
end);

InstallOtherMethod(Remove,
  "a canvas, a list of francy objects",
  true,
  [IsCanvas,
   IsList],
  0,
function(canvas, objects)
  local object;
  for object in objects do
    Remove(canvas, object);
  od;
  return canvas;
end);

#############################################################################
##
#M  Draw( ) . . . . . 
##
InstallMethod(Draw,
  "",
  true,
  [IsCanvas],
  0,
function(canvas)
  local object;
  object := rec();
  object!.agent := FrancyMIMEType;
  object!.canvas := Clone(canvas);
  return rec(json := true, source := "gap", data := rec((FrancyMIMEType) := GapToJsonString(object)));
end);