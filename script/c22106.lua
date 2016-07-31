 
--幻在「死者之时」
function c22106.initial_effect(c)
	c:EnableCounterPermit(0x28c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22106.tg1)
	e1:SetOperation(c22106.op)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c22106.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(22106,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetLabel(1)
	e4:SetCost(c22106.cost)
	e4:SetTarget(c22106.tg)
	e4:SetOperation(c22106.op)
	c:RegisterEffect(e4)
end
function c22106.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()~=tp and 
		Duel.IsCanRemoveCounter(tp,1,0,0x28c,2,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(22106,1)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.RemoveCounter(tp,1,0,0x28c,2,REASON_COST)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		e:SetCategory(CATEGORY_DESTROY)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(22106,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c22106.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x813)
end
function c22106.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c22106.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x28c,1)
	end
end
function c22106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x28c,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x28c,2,REASON_COST)
end
function c22106.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return e:GetHandler():GetFlagEffect(22106)==0 and Duel.GetTurnPlayer()~=tp end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(22106,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c22106.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
