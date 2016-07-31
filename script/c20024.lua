 
--莱拉·普莉兹姆利巴
function c20024.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),3,2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(20024,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c20024.condition)
	e1:SetCost(c20024.cost)
	e1:SetTarget(c20024.target)
	e1:SetOperation(c20024.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(20024,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20024.condition2)
	e2:SetCost(c20024.cost)
	e2:SetTarget(c20024.target2)
	e2:SetOperation(c20024.activate2)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c20024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_GRAVE,nil)<8
end
function c20024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ctb=0
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPIRIT) then
		ctb=2
	else
		ctb=1
	end
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return e:GetHandler():GetFlagEffect(20024)==0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ctb,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(20024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c20024.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c20024.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_GRAVE,nil)>=8
end
function c20024.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ctb=0
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPIRIT) then
		ctb=2
	else
		ctb=1
	end
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return e:GetHandler():GetFlagEffect(20024)==0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3*ctb,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(20024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c20024.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
