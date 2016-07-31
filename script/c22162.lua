 
--七曜-月符「寂静的月神」
--require "expansions/nef/msc"
function c22162.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22162,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22162.cost)
	e2:SetTarget(c22162.postg)
	e2:SetOperation(c22162.posop)
	c:RegisterEffect(e2)
	Msc.RegScMixEffect(c)
end
function c22162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22162)==0 end
	Duel.RegisterFlagEffect(tp,22162,RESET_PHASE+PHASE_END,0,1)
end
function c22162.filter(c)
	return not c:IsPosition(POS_FACEUP_DEFENCE)
end
function c22162.dactfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x811)
end
function c22162.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c22162.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22162.filter,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(c22162.dactfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22162.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22162.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,2)
		--tc:RegisterEffect(e1)
	end
end
