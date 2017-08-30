--庭师的剑鞘
function c20188.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c20188.cost)
	e1:SetTarget(c20188.target)
	e1:SetOperation(c20188.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20188,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,20188)
	e2:SetCondition(c20188.con)
	e2:SetCost(c20188.thcost)
	e2:SetOperation(c20188.op)
	c:RegisterEffect(e2)
end
function c20188.cfilter(c)
	return c:IsSetCard(0x201) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c20188.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20188.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c20188.cfilter,1,1,REASON_COST,nil)
end
function c20188.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c20188.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c20188.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c20188.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>0
end
function c20188.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c20188.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c20188.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
