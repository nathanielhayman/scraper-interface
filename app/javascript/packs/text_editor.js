var pressedKeys = [];

function pasteHtmlAtCaret(html) {
    var sel, range;
    if (window.getSelection) {
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();

            var el = document.createElement("div");
            el.innerHTML = html;
            var frag = document.createDocumentFragment(), node, lastNode;
            while ( (node = el.firstChild) ) {
                lastNode = frag.appendChild(node);
            }
            range.insertNode(frag);

            if (lastNode) {
                range = range.cloneRange();
                range.setStartAfter(lastNode);
                range.collapse(true);
                sel.removeAllRanges();
                sel.addRange(range);
            }
        }
    } else if (document.selection && document.selection.type != "Control") {
        document.selection.createRange().pasteHTML(html);
    }
}

function getCaretPosition() {
    if (window.getSelection && window.getSelection().getRangeAt) {
      var range = window.getSelection().getRangeAt(0);
      var selectedObj = window.getSelection();
      var rangeCount = 0;
      var childNodes = selectedObj.anchorNode.parentNode.childNodes;
      for (var i = 0; i < childNodes.length; i++) {
        if (childNodes[i] == selectedObj.anchorNode) {
          break;
        }
        if (childNodes[i].outerHTML)
          rangeCount += childNodes[i].outerHTML.length;
        else if (childNodes[i].nodeType == 3) {
          rangeCount += childNodes[i].textContent.length;
        }
      }
      return range.startOffset + rangeCount;
    }
    return -1;
  }

document.addEventListener('keyup', function(e) {
    if (e.defaultPrevented) {
        return;
    }
    
    switch (e.key) {
        case "Control": 
        case "Alt": 
        case "Shift":
        case "CapsLock":
        case "ArrowUp": 
        case "ArrowDown": 
        case "ArrowLeft":
        case "ArrowRight":
                pressedKeys.pop(e.key);
            break;
        default:
            return;
    }
});

document.addEventListener('keydown', function(e) {

    if (e.defaultPrevented) {
        return;
    }

    var textarea = document.getElementsByClassName('ztextarea')[0];

    switch (e.key) {
        case "Control": 
        case "Alt": 
        case "Shift":
        case "CapsLock":
        case "ArrowUp": 
        case "ArrowDown": 
        case "ArrowLeft":
        case "ArrowRight":
            pressedKeys.push(e.key);
            break;
        case "Enter":
            e.preventDefault();
            pasteHtmlAtCaret('<br>');
            break;
        case "Tab":
            e.preventDefault();
            var tabLength = 8;
            var sequence = "\u00a0".repeat(tabLength);
            pasteHtmlAtCaret(`<tab class="tab-char">${sequence}</tab>`);
            break;
        case " ":
            console.log("space");
            e.preventDefault();
            var spaceLength = 4;
            var sequence = "\u00a0".repeat(spaceLength);
            pasteHtmlAtCaret(`${sequence}`);
        case "Backspace":
            console.log(textarea.children);
            if (window.getSelection) {
                var selectedObj = window.getSelection();
                if (selectedObj.anchorNode.nodeName != "DIV") {
                    var container = selectedObj.anchorNode.parentNode;
                    if(container.nodeName == "TAB") {
                        e.preventDefault();
                        textarea.removeChild(container);
                    }
                }
            }
            //if (textarea.lastChild.nodeName == "TAB") {
            //    e.preventDefault();
            //    textarea.removeChild(textarea.lastChild);
            //}
            break;
        case "F11":
            textarea.style.width = "100%";
            textarea.style.height = "100%";
            if (elem.requestFullscreen) {
                elem.requestFullscreen();
            } else if (elem.webkitRequestFullscreen) {
                elem.webkitRequestFullscreen();
            } else if (elem.msRequestFullscreen) {
                elem.msRequestFullscreen();
            }
            break;
        default:
            if (!pressedKeys.includes("Control", "Alt", "Shift")) {
                var selectedObj = window.getSelection();
                console.log(textarea.children[textarea.children.length-1].nodeName);
                if (!selectedObj.anchorNode.nodeName == "#text" || !textarea.children) {
                    if (selectedObj.anchorNode.nodeName == "DIV" && 
                        !textarea.children[textarea.children.length-1].nodeName == "TAB") {
                            break;
                    } else {
                        e.preventDefault();
                        pasteHtmlAtCaret(`${e.key}`);
                    }
                }
            }
    }
});