--正体不明✿鬼人正邪
function c19013.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x260),aux.FilterBoolFunction(Card.IsSetCard,0x251c),true)

		--destroy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19013,0))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(c19013.cgcon)
		e1:SetTarget(c19013.target)
		e1:SetOperation(c19013.operation)
		c:RegisterEffect(e1)

			--atkup
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_DAMAGE_CALCULATING)
			e2:SetCondition(c19013.atkcon)
			e2:SetOperation(c19013.atkop)
			c:RegisterEffect(e2)

		--copy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(19013,1))
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTarget(c19013.costg)
		e3:SetOperation(c19013.cosop)
		c:RegisterEffect(e3)

end


function c19013.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end


function c19013.desfilter(c,atk)
	return c:IsDestructable() and c:GetAttack()~=atk and c:IsFaceup()
end


function c19013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	local ct=Duel.GetMatchingGroupCount(c19013.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),atk)
	if chk==0 then return ct>0 end
	if ct>2 then ct=2 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,0,0)
end


function c19013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local g=Duel.GetMatchingGroup(c19013.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,atk)
	local sg=g:RandomSelect(tp,2)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		c:RegisterFlagEffect(19013,RESET_EVENT+0x1fe0000,0,0)
	end
end


function c19013.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetFlagEffect(19013)==0
end


function c19013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ct*800)
	e:GetHandler():RegisterEffect(e1)
end


function c19013.filter(c)
	return c:IsFaceup() and not c:IsForbidden()
end


function c19013.costg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x1c) and c19013.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(19013)==0 and Duel.IsExistingTarget(c19013.filter,tp,0x1c,0x1c,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c19013.filter,tp,0x1c,0x1c,1,1,nil)
end


function c19013.cosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
	end
end

