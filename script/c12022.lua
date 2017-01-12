--明净翼之恶灵✿魅魔
function c12022.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--啊！光明啊！
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12022,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12022.eqcon)
	e1:SetTarget(c12022.eqtg)
	e1:SetOperation(c12022.eqop)
	c:RegisterEffect(e1)
	--laipigou
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12022,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c12022.damcost)
	e2:SetOperation(c12022.damop)
	c:RegisterEffect(e2)
end
function c12022.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c12022.filter(c)
	return c:IsDestructable() and c:IsAbleToRemove()
end
function c12022.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c12022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12022.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12022.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c12022.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsFaceup() then
		if Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED) > 0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(1000)
			c:RegisterEffect(e2)
		end
	else
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c12022.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12022.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(c12022.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c12022.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c12022.tg(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function c12022.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL))
end
