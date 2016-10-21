--禁忌『红莓陷阱』
local M = c999411
local Mid = 999411
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(Mid, 1))
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(M.condition)
	e2:SetTarget(M.target)
	e2:SetOperation(M.activate)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Activate and use effect
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetDescription(aux.Stringid(Mid, 2))
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetDescription(aux.Stringid(Mid, 3))
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(M.setcost)
	e4:SetTarget(M.settg)
	e4:SetOperation(M.setop)
	c:RegisterEffect(e4)
end

M.DescSetName = 0xa3 

function M.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code=rc:GetOriginalCode()
	local mt=_G["c" .. code]
	return ep==tp and mt and mt.DescSetName == 0xa3
end

function M.filter(c)
	return c:IsDestructable()
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(M.filter, rp, 0, LOCATION_ONFIELD, 1, nil) end
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev, g)
	Duel.ChangeChainOperation(ev, M.repop)
end

function M.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectMatchingCard(tp, M.filter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g, REASON_EFFECT)
	end
end

function M.costfilter(c)
	return c:IsCode(Mid) and c:IsAbleToRemoveAsCost()
end

function M.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(M.costfilter, tp, LOCATION_GRAVE, 0, nil)
	local rep = Duel.GetFlagEffect(tp, 999410)
	local num = 2 - rep
	if num < 1 then num = 1 end
	if chk==0 then return g:GetCount()>=num end
	local rg=g:RandomSelect(tp,num)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp, 999410)
end

function M.setfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa3 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end

function M.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_SZONE)>0
		and Duel.IsExistingTarget(M.setfilter, tp, LOCATION_DECK, 0, 1, nil) end
end

function M.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectTarget(tp, M.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	local tc=g:GetFirst()
	if tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp, tc)
		Duel.ConfirmCards(1-tp, tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		if Duel.GetTurnPlayer()==tp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN, 2)
		else
			e1:SetLabel(0)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		e1:SetLabelObject(tc)
		e1:SetCondition(M.rmcon)
		e1:SetOperation(M.rmop)
		Duel.RegisterEffect(e1, tp)
		tc:CreateEffectRelation(e1)
	end
end

function M.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp
end

function M.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc, REASON_EFFECT)
	end
end
