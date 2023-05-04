%
%  Simplier draw_arena() function originated from homeworks.
%  Draws the current layout of the arena.
%
%  Inputs:  None
%  Outputs: None

function draw_arena()

global arena_map

xmin = 0;
xmax = 10;
ymin = 0;
ymax = 10;

line([xmin xmin xmax xmax xmin], [ymin ymax ymax ymin ymin]);

for i = 1:length(arena_map);
  obstacle = arena_map{i};
  patch(obstacle(:,1), obstacle(:,2),'black');
end

axis tight;
axis square;
grid on;

end
