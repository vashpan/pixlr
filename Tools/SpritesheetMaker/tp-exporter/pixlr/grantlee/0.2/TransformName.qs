var StripPathSeparators = function(input)
{
  var input = input.rawString();
  input = input.replace(/\s+/g,"_");
  input = input.replace(/\\+/g,"_");
  input = input.replace(/\/+/g,"_");
  return input.charAt(0).toUpperCase() + input.slice(1);
};

var SwiftifyPath = function(input)
{
  var input = input.rawString();
  var parts = input.split("/");
  var finalParts = new Array(parts.length);
  for(i in parts) {
    var part = parts[i].trim();

    // join each part into a single word
    part = part.split(/\s+/).join("");

    // capitalize each part
    if(i == 0) {
      part = part.charAt(0).toLowerCase() + part.slice(1);
    } else {
      part = part.charAt(0).toUpperCase() + part.slice(1);
    }

    finalParts.push(part);
  }

  return finalParts.join("");
};

var ClassName = function(input) {
  var input = input.rawString();
  return input.charAt(0).toUpperCase() + input.slice(1);
};

StripPathSeparators.filterName = "stripPathSeparators";
StripPathSeparators.isSafe = false;

SwiftifyPath.filterName = "swiftifyPath";
SwiftifyPath.isSafe = false;

ClassName.filterName = "className";
ClassName.isSafe = false;

Library.addFilter("ClassName");
Library.addFilter("SwiftifyPath");
Library.addFilter("StripPathSeparators");
