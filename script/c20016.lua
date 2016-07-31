 
--春之妖精 莉莉布莱克
--require "expansions/nef/nef"
function c20016.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Nef.AddXyzProcedureWithDesc(c,nil,3,3,aux.Stringid(20016,1))
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(c20016.xyzfilter),3,2,aux.Stringid(20016,2))
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(20016,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20016.cost)
	e1:SetTarget(c20016.target)
	e1:SetOperation(c20016.operation)
	c:RegisterEffect(e1)
end
function c20016.xyzfilter(c)
	return c:IsSetCard(0x123) or c:IsCode(20013)
end
function c20016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c20016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c20016.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
