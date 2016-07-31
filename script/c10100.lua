--require "expansions/nef/nef"
--幻想年祭『博丽神社·冬』
function c10100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100.target)
	e1:SetOperation(c10100.activate)
	c:RegisterEffect(e1)
end
function c10100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c10100.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local c,n,m = Nef.GetDate()
	if (n==12 or n<3) and Duel.SelectYesNo(tp,aux.Stringid(10100,0)) then
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
end
