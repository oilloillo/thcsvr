 
--米斯蒂娅·萝蕾拉
function c21003.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21003,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_RELEASE)
	e1:SetTarget(c21003.target)
	e1:SetOperation(c21003.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c21003.condition)
	c:RegisterEffect(e2)
end
function c21003.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c21003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function c21003.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
