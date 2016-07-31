 
--ÑýÄ§Êé±ä»¯ í³¼Õ
function c21470013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470013.tg)
	e1:SetOperation(c21470013.op)
	c:RegisterEffect(e1)
end
function c21470013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,21470013,0,0x21,1000,1800,4,RACE_BEAST,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21470013.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21470013,0,0x21,1000,1800,4,RACE_BEAST,ATTRIBUTE_DARK) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT+TYPE_TUNER,ATTRIBUTE_DARK,RACE_BEAST,4,1000,1800)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
	--handdes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470013,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c21470013.condition)
	e1:SetTarget(c21470013.target)
	e1:SetOperation(c21470013.operation)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(c21470013.syncon)
	e2:SetValue(c21470013.synlimit)
	c:RegisterEffect(e2,true)
	--XYZ limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetCondition(c21470013.syncon)
	e3:SetValue(c21470013.synlimit)
	c:RegisterEffect(e3,true)
	--[[release sum limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(1)
	c:RegisterEffect(e4,true)]]
end
function c21470013.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21470013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c21470013.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
	local sg=g:RandomSelect(ep,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c21470013.syncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCode()==e:GetHandler():GetOriginalCode()
end
function c21470013.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x742)
end
