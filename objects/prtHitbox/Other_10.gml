/// @description Update hitbox
if (!instance_exists(owner))
    exit;

image_xscale = scaleX * owner.image_xscale;
image_yscale = scaleY * owner.image_yscale;
x = owner.x + offsetX * owner.image_xscale;
y = owner.y + offsetY * owner.image_yscale;
