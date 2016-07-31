 
--梦幻的打击乐手✿堀川雷鼓
function c29024.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c29024.sfilter),aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29024,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c29024.target)
	e2:SetOperation(c29024.operation)
	c:RegisterEffect(e2)
end
function c29024.sfilter(c)
	return c:GetAttack()<=400
end
function c29024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return (ct>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,e:GetHandler()))
		or Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if ct==0 then
		g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
		if g:GetFirst():GetControler()==tp then
			e:SetCategory(CATEGORY_ATKCHANGE)
		else
			e:SetCategory(CATEGORY_CONTROL)
			Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
		end
	end
end
function c29024.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	e5:SetCondition(c29024.rdcon)
	e5:SetOperation(c29024.rdop)
	c:RegisterEffect(e5)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetControler()~=tp then
			local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			if g1:GetCount()>0 then
				local sg1=g1:RandomSelect(tp,1)
				Duel.SendtoGrave(sg1,REASON_EFFECT)
			end
			if Duel.GetControl(tc,tp) then
				if not tc:IsType(TYPE_PENDULUM) then 
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_CANNOT_ATTACK)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e2)
				end
			elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		elseif tc:IsFaceup() then
			local atk=c:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+0xff0000)
			e1:SetValue(atk)
			tc:RegisterEffect(e1)
		end
	end
end
function c29024.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker()
end
function c29024.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end
