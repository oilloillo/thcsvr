 
--因幡 狂气的月之兔
function c21061.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x256),1)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21061,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c21061.tg)
	e1:SetOperation(c21061.op)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	--e2:SetCondition(c21061.drcon)
	e2:SetTarget(c21061.destg)
	e2:SetOperation(c21061.desop)
	c:RegisterEffect(e2)
end
function c21061.filter(c)
	return c:IsFaceup()
end
function c21061.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21061.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sel=0
	sel=Duel.SelectOption(tp,aux.Stringid(21061,1),aux.Stringid(21061,2))
	e:SetLabel(sel)
	local g=Duel.GetMatchingGroup(c21061.filter,tp,0,LOCATION_MZONE,nil)
	if sel==0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
	else
		local tg=g:GetMaxGroup(Card.GetAttack)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,tg:GetCount(),0,0)
	end
end
function c21061.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local g=Duel.GetMatchingGroup(c21061.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		if sel==0 then
			local tg=g:GetMinGroup(Card.GetAttack)
			Duel.Destroy(tg,REASON_EFFECT)
		else
			local tg=g:GetMaxGroup(Card.GetAttack)
			Duel.ChangePosition(tg,POS_FACEDOWN_DEFENCE)
		end
	end
end
function c21061.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21061.desfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c21061.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21061.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21061.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21061.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21061.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
