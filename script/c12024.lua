--暗影翼之恶灵✿魅魔
function c12024.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),5,2,nil,nil,5)
	c:EnableReviveLimit()
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c12024.adval)
	c:RegisterEffect(e2)
	--啊！黑暗啊！
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12024,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c12024.descost)
	e5:SetTarget(c12024.destg)
	e5:SetOperation(c12024.desop)
	c:RegisterEffect(e5)
end
function c12024.adval(e,c)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)*500
end
function c12024.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12024.desfilter(c)
	return c:IsAbleToRemove() and c:IsDestructable()
end
function c12024.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c12024.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12024.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12024.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c12024.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFacedown() and Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)>0 then
			Duel.Damage(1-tp,tc:GetDefense(),REASON_EFFECT)
		else
			Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		end
	end
end
