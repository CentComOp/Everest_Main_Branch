/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	flag = "bullet"
	sharp = 1
	edge = 1

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/bullet/gyro/law
	name ="high-ex round"
	icon_state= "bolter"
	damage = 15
	flag = "bullet"

/obj/item/projectile/bullet/gyro/law/on_hit(var/atom/target, var/blocked = 0)

	explosion(target, -1, 0, 2)
	sleep(0)
	var/obj/T = target
	var/throwdir = get_dir(firer,target)
	T.throw_at(get_edge_target_turf(target, throwdir),3,3)
	return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	//var/temperature = 300


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = -273
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	flag = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.meteorhit(src)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				del(src)
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/M = target
//		if(ishuman(target) && M.dna && M.dna.mutantrace == "plant") //Plantmen possibly get mutated and damaged by the rays.
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
				if(prob(15))
					M.apply_effect((rand(30,80)),IRRADIATE)
					M.Weaken(5)
					for (var/mob/V in viewers(src))
						V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
				if(prob(35))
				//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
				//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
					if(prob(80))
						randmutb(M)
						domutcheck(M,null)
					else
						randmutg(M)
						domutcheck(M,null)
				else
					M.adjustFireLoss(rand(5,15))
					M.show_message("\red The radiation beam singes you!")
				//	for (var/mob/V in viewers(src))
				//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
		else if(istype(target, /mob/living/carbon/))
		//	for (var/mob/V in viewers(src))
		//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
//		if(ishuman(target) && M.dna && M.dna.mutantrace == "plant") //These rays make plantmen fat.
		if(ishuman(target)) //These rays make plantmen fat.
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
				M.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.adjustBrainLoss(20)
			M.hallucination += 20

/obj/item/projectile/bullet/odd
	embed = 1
	sharp = 1
	damage = 30


//vampire stuff!
/obj/item/projectile/bullet/vamp
	damage = 0
	nodamage = 1
	embed = 0
	sharp = 0

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(M.mind.vampire)
			M.Weaken(15)
			M.show_message("\red Your muscles weaken and you flop to the floor, that bullet must have been silver!")
		else if (istype(target, /mob/living/carbon/))
			M.show_message("\blue That sort of hurt, a little!")
		else
			return 1


/obj/item/projectile/bullet/ball
	damage = 0
	sharp = 0
	embed = 0
	agony = 60

/obj/item/projectile/bullet/odd/toxin
	damage_type = TOX

/obj/item/projectile/bullet/odd/burn
	damage_type = BURN

/obj/item/projectile/bullet/odd/clone
	damage_type = CLONE


//ammo types for the .44's.

//Anti-Vampire
/obj/item/projectile/bullet/custom/vamp
	damage = 10
	agony = 15

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/carbon/M = target
		if(M.mind.vampire)
			M.adjust_fire_stacks(1)
			M.IgniteMob()
			M.show_message("\red You burst into flames as you are hit by the bullet, it must have contained holy water!")
		else
			return 1

//Stun
/obj/item/projectile/bullet/custom/stun
	damage = 5
	agony = 60

//Incendiary (ignite)
/obj/item/projectile/bullet/custom/incendiary
	damage = 5

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/carbon/M = target
		if(istype(target, /mob/living/carbon/))
			M.adjust_fire_stacks(1)
			M.IgniteMob()
		else
			return 1

//Freeze
/obj/item/projectile/bullet/custom/freeze
	damage = 5

	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = -273
		return 1

//High Impact (could deal melee damage instead of bullet)
/obj/item/projectile/bullet/custom/highimpact
	damage = 40
	flag = "melee"
	agony = 10

//Normal
/obj/item/projectile/bullet/custom/standard
	damage = 40
	agony = 5

//EMP
/obj/item/projectile/bullet/custom/emp
	damage = 10
	agony = 5

	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1

//Poison/Radiation
/obj/item/projectile/bullet/custom/rad
	damage = 20
	damage_type = TOX
	irradiate = 10
	agony = 5
	flag = "rad"

//Energy
/obj/item/projectile/bullet/custom/energy
	damage = 40
	damage_type = BURN
	flag = "energy"

//High Explosive (HE)
/obj/item/projectile/bullet/custom/explosive
	damage = 30

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

//Armor Piercing (will need to find a way to get past armor check)

//Anti-Personnel (deals organ damage)

//Insanity (makes people see things, no physical damage)
/obj/item/projectile/bullet/custom/insane
	damage = 10
	agony = 5

	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living))
			var/mob/living/carbon/human/M = target
			M.hallucination += 20

//Sleep (makes person fall asleep)
/obj/item/projectile/bullet/custom/sleepy
	damage = 5
	agony = 5
	eyeblur = 10
	drowsy = 15

//Muscle Stop (weakens)
/obj/item/projectile/bullet/custom/weaken
	damage = 5
	agony = 15
	weaken = 15