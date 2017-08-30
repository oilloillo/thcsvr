 
--长门型战舰-长门
function c50001.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x4bb),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50001,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c50001.eqtg2)
	e2:SetOperation(c50001.eqop2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50001,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c50001.descost3)
	e3:SetTarget(c50001.destg3)
	e3:SetOperation(c50001.desop3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--attack cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c50001.atcost5)
	e5:SetOperation(c50001.atop5)
	c:RegisterEffect(e5)
end
function c50001.filter2(c)
	return c:IsCode(50808)
end
function c50001.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c50001.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function c50001.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c50001.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c50001.descost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c50001.destg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c50001.desop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk1 = e:GetHandler():GetAttack()
		local atk2 = tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT) ~= 0 and atk1>atk2 then
			Duel.Damage(1-tp,atk1-atk2,REASON_EFFECT)
		end
	end
end
function c50001.atcost5(e,c,tp)
	return Duel.CheckLPCost(tp,1000)
end
function c50001.atop5(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1000)
end