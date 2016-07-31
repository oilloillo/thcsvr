 
--魔操「回归虚无」
function c20158.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c20158.cost)
	e1:SetTarget(c20158.target)
	e1:SetOperation(c20158.activate)
	c:RegisterEffect(e1)
end
function c20158.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x186) and c:IsRace(RACE_MACHINE)
end
function c20158.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c20158.cfilter,tp,LOCATION_GRAVE,0,nil)
	local gc=g:GetCount()
	if chk==0 then return gc>0 end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(gc)
end
function c20158.filter(c)
	return c:IsDestructable()
end
function c20158.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c20158.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20158.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20158.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local gc=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,gc*300+1000)
end
function c20158.activate(e,tp,eg,ep,ev,re,r,rp)
	local gc=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		Duel.Damage(1-tp,gc*300+1000,REASON_EFFECT)
	end
end
