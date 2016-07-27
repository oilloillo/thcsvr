--引发沉船的念缚灵✿村纱水蜜
function c26110.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SetCard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e1:SetValue(0x251)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26110.sccon)
	e2:SetTarget(c26110.splimit)
	c:RegisterEffect(e2)
	--devil move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(26110,0))
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c26110.target1)
	e3:SetOperation(c26110.operation1)
	--c:RegisterEffect(e3)
	--to extra
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(26110,0))
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,26110)
	e3:SetTarget(c26110.target1)
	e3:SetOperation(c26110.operation1)
	c:RegisterEffect(e3)
	--scale up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26110,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,26110)
	e4:SetTarget(c26110.target)
	e4:SetOperation(c26110.operation)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26110,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,261100)
	e5:SetTarget(c26110.thtg)
	e5:SetOperation(c26110.thop)
	c:RegisterEffect(e5)
	--level up
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26110,3))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c26110.lvtg)
	e6:SetOperation(c26110.lvop)
	c:RegisterEffect(e6)
end
function c26110.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or tc:GetOriginalAttribute()==e:GetHandler():GetOriginalAttribute()
end
function c26110.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
-- function c26110.target1(e,tp,eg,ep,ev,re,r,rp,chk)
-- 	local c=e:GetHandler()
-- 	local seq=c:GetSequence()
-- 	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
-- 	if chk==0 then return not tc end
-- end
-- function c26110.operation1(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	local seq=c:GetSequence()
-- 	if c:IsFaceup() and c:IsRelateToEffect(e) then
-- 		local lsc=c:GetLeftScale()
-- 		local rsc=c:GetRightScale()
-- 		local e1=Effect.CreateEffect(c)
-- 		e1:SetType(EFFECT_TYPE_SINGLE)
-- 		e1:SetCode(EFFECT_CHANGE_LSCALE)
-- 		e1:SetValue(rsc)
-- 		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
-- 		c:RegisterEffect(e1)
-- 		local e2=e1:Clone()
-- 		e2:SetCode(EFFECT_CHANGE_RSCALE)
-- 		e2:SetValue(lsc)
-- 		c:RegisterEffect(e2)
-- 	end
-- end
function c26110.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if chk==0 then return tc and tc:IsSetCard(0x251) and c:IsAbleToExtra() end
end
function c26110.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.PSendtoExtra(c,nil,REASON_EFFECT)
	end
end
function c26110.cfilter(c)
	return c:IsType(TYPE_FIELD)
end
function c26110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c26110.cfilter,tp,LOCATION_GRAVE,0,nil)>0 end
end
function c26110.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=Duel.GetMatchingGroupCount(c26110.cfilter,tp,LOCATION_GRAVE,0,nil)
	if scl>5 then scl=5 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(scl)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
function c26110.filter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c26110.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26110.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26110.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26110.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c26110.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c26110.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x208)
end
function c26110.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26110.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26110.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26110.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26110.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=0
		if tc:IsType(TYPE_XYZ) then
			lv=tc:GetRank()
		else
			lv=tc:GetLevel()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
