 
--蓬莱人形
function c20049.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20049,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c20049.condition)
	e1:SetTarget(c20049.target)
	e1:SetOperation(c20049.operation)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetTarget(c20049.tg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c20049.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c20049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c20049.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c20049.tg(e,c)
	return c:IsSetCard(0x300) and c:IsLevelAbove(5)
end