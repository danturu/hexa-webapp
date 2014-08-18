define ->
  class Grid
    constructor: (w, h, baseW, baseH, viewS, strokeW) ->
      @cell = strokeW: strokeW; @grid = viewS: viewS;

      if w * 3/4 > h
        @cell.w = (viewS - strokeW * (w - 1)) / w
        @cell.h = @cell.w * (Math.sqrt(3) / 2)
      else
        @cell.h = (viewS - strokeW * (h - 1)) / h
        @cell.w = @cell.h / (Math.sqrt(3) / 2)

      @grid.h = @cell.h * h       + (strokeW * (h - 1))
      @grid.w = @cell.w * h * 3/4 + (strokeW * (w - 1))

      @grid.offsetX = (viewS - @grid.w) / 2
      @grid.offsetY = (viewS - @grid.h) / 2

      @cell.scaleIn = (@cell.w / baseW + @cell.h / baseH) / 2

    getX: (x) -> 3/4 * ((@cell.w + @cell.strokeW) * x) + (@cell.w / 2) + @grid.offsetX
    getY: (y) -> 1/2 * ((@cell.h + @cell.strokeW) * y) + (@cell.h / 2) + @grid.offsetY

    scaleIn: ->
      @cell.scaleIn

    perimeter: (x, y, r) ->
      return [
        { x: x - 0, y: y - 0 },
      ] if r == 0

      return [
        { x: x - 0, y: y - 2 },
        { x: x - 1, y: y - 1 }, { x: x + 1, y: y - 1 },
        { x: x - 1, y: y + 1 }, { x: x + 1, y: y + 1 },
        { x: x - 0, y: y + 2 },
      ] if r == 1

      return [
        { x: x - 0, y: y - 4 },
        { x: x - 1, y: y - 3 }, { x: x + 1, y: y - 3 },
        { x: x - 2, y: y - 2 }, { x: x + 2, y: y - 2 },
        { x: x - 2, y: y - 0 }, { x: x + 2, y: y - 0 },
        { x: x - 2, y: y + 2 }, { x: x + 2, y: y + 2 },
        { x: x - 1, y: y + 3 }, { x: x + 1, y: y + 3 },
        { x: x - 0, y: y + 4 },
      ] if r == 2

  # EXPORTS

  Grid : Grid
