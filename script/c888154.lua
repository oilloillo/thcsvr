 
--七曜-金符「银龙」
function c888154.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(600)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(888154,1))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c888154.target)
	e6:SetOperation(c888154.operation)
	c:RegisterEffect(e6)
end
function c888154.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c888154.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		local c=e:GetHandler()
			local tc=Duel.GetFirstTarget()
				local a=tc:GetAttack()
					local d=tc:GetDefence()
						local ad=a+d
							local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_SINGLE)
									e1:SetCode(EFFECT_SET_ATTACK_FINAL)
										e1:SetValue(0)
											e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
										tc:RegisterEffect(e1)
									local e2=Effect.CreateEffect(c)
								e2:SetType(EFFECT_TYPE_SINGLE)
							e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
						e2:SetValue(0)
					e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			local s=math.ceil(ad/1500)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,s,s,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
