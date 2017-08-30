 
--伊势型战舰-日向
function c50009.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x4bb),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50009,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c50009.eqtg2)
	e2:SetOperation(c50009.eqop2)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50009,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c50009.target3)
	e3:SetOperation(c50009.operation3)
	c:RegisterEffect(e3)
	--attack cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c50009.atcost5)
	e5:SetOperation(c50009.atop5)
	c:RegisterEffect(e5)
end
function c50009.filter2(c)
	return c:IsCode(50807)
end
function c50009.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c50009.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function c50009.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c50009.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c50009.filter3(c)
	return c:IsFaceup() and (c:IsSetCard(0x4bb) or (c:GetEquipTarget() and c:GetEquipTarget():IsSetCard(0x4bb)))
end
function c50009.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c50009.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50009.filter3,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c50009.filter3,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c50009.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
end

function c50009.atcost5(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c50009.atop5(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end