 
--美丽的绯之衣 永江衣玖
function c25006.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),4,2)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25006,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c25006.damcon)
	e1:SetCost(c25006.cost)
	e1:SetTarget(c25006.damtg)
	e1:SetOperation(c25006.damop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25007,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c25006.drcon)
	e2:SetTarget(c25006.drtg)
	e2:SetOperation(c25006.drop)
	c:RegisterEffect(e2)
end
function c25006.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return c==e:GetHandler()
end
function c25006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c25006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then	return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c25006.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,Duel.GetAttacker():GetAttack(),REASON_EFFECT)
end
function c25006.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
		and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c25006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c25006.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
