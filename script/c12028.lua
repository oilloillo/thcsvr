 --咒子
function c12028.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12028,0))
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCondition(c12028.condition)
	e5:SetOperation(c12028.operation)
	c:RegisterEffect(e5)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12028,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c12028.descost)
	e2:SetTarget(c12028.destg)
	e2:SetOperation(c12028.desop)
	c:RegisterEffect(e2)
end
function c12028.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c12028.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCondition(c12028.condition)
	e1:SetOperation(c12028.op)
	Duel.RegisterEffect(e1,tp)
end
function c12028.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,900,REASON_EFFECT)
end
function c12028.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c12028.desfilter(c)
	return c:IsAttackPos()
end
function c12028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c12028.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12028.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12028.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12028.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
