 
--暗中蠢动的光虫 莉格露
function c21064.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),1,2)
	c:EnableReviveLimit()
	--cannot destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21064.condition1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21064.condition2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21064,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1c0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c21064.condition)
	e3:SetCost(c21064.cost)
	e3:SetTarget(c21064.target)
	e3:SetOperation(c21064.operation)
	c:RegisterEffect(e3)
end
function c21064.condition1(e)
	local gm=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)
	local gy=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_MZONE)
	return gm<gy
end
function c21064.condition2(e)
	local gm=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)
	local gy=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_MZONE)
	return gm>gy
end
function c21064.condition(e,tp,eg,ep,ev,re,r,rp)
	local gm=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local gy=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	return gm==gy
end
function c21064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21064.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c21064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c21064.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21064.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21064.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21064.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
