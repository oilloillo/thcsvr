 
--符器-人魂灯
function c200208.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c200208.activate)
	c:RegisterEffect(e1)
end
function c200208.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--turn count
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetLabel(0)
	e0:SetOperation(c200208.count)
	e0:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e0,tp)
end
function c200208.count(e,tp,eg,ep,ev,re,r,rp)
	if tp==Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if(ct<3) then
		ct=ct+1
		e:SetLabel(ct)
		c:SetTurnCounter(ct)
		local lp=Duel.GetLP(1-tp)
		if lp>500 then Duel.SetLP(1-tp,lp-500)
		else Duel.SetLP(1-tp,0)	end
	end
end