--天候-凪
function c200116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(200116,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c200116.rtg)
	e3:SetOperation(c200116.rop)
	c:RegisterEffect(e3)
end
function c200116.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c200116.rop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Recover(tp,500,REASON_EFFECT)
end