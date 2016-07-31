 
--星光妖精 斯塔·莎菲雅
function c25022.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25022,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c25022.drcon)
	e1:SetCost(c25022.cost)
	e1:SetTarget(c25022.drtg)
	e1:SetOperation(c25022.drop)
	c:RegisterEffect(e1)
	--deck destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25022,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c25022.target)
	e2:SetOperation(c25022.operation)
	c:RegisterEffect(e2)
end
function c25022.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<2
end
function c25022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,25022)==0 end
	Duel.RegisterFlagEffect(tp,25022,RESET_PHASE+PHASE_END,0,1)
end
function c25022.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c25022.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c25022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c25022.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
