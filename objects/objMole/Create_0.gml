event_inherited();

burrowBitField = 0;
bitMask_FullyExposed = 0b00;
bitMask_TailExposed = 0b01;
bitMask_HeadExposed = 0b10;
bitMask_FullyBuried = 0b11;
headBit = (1 << 0);
tailBit = (1 << 1);

__spawnedBurrowed = false;
__dealDamageDelay = -1;