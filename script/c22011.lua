 
--红魔-红美铃
function c22011.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22011,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c22011.retcon)
	e1:SetTarget(c22011.rettg)
	e1:SetOperation(c22011.retop)
	c:RegisterEffect(e1)
	--mam
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(c22011.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c22011.efilter(e,c)
	return c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117)
end
function c22011.retcon(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(t)
	return t and t:IsRelateToBattle()
end
function c22011.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then	return e:GetLabelObject():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetLabelObject(),1,0,0)
end
function c22011.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsRelateToBattle() then
		Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
	end
end