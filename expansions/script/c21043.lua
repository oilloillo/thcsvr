 
--神宝「蓬莱的玉枝 -梦色之乡-」
function c21043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21043,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21043.con)
	e2:SetOperation(c21043.op)
	c:RegisterEffect(e2)
end
function c21043.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x256)
end
function c21043.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,21043)
	Duel.Draw(tp,1,REASON_EFFECT)
end
