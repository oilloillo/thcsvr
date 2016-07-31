 
--吸血鬼之宠✿卓柏卡布拉
function c21470011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470011.tg)
	e1:SetOperation(c21470011.op)
	c:RegisterEffect(e1)
end
function c21470011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,21470011,0,0x11,1700,1700,4,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21470011.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21470011,0,0x11,1700,1700,4,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddTrapMonsterAttribute(TYPE_NORMAL+TYPE_TUNER,ATTRIBUTE_DARK,RACE_FIEND,4,1700,1700)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()--[[
	--Race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(c21470011.synlimit)
	c:RegisterEffect(e2,true)
	--XYZ limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(c21470011.synlimit)
	c:RegisterEffect(e3,true)
	--release sum limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(1)
	c:RegisterEffect(e4,true)]]
end--[[
function c21470011.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_DARK)
end]]
