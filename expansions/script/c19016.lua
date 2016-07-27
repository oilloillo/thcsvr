--天手力男之投✿古明地觉
function c19016.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x214a),aux.FilterBoolFunction(Card.IsSetCard,0xaa5),true)

		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19016,0))
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c19016.target)
		e1:SetOperation(c19016.operation)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e2)

		--negate
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(19016,1))
		e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_DAMAGE)
		e3:SetCode(EVENT_CHAINING)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e3:SetCountLimit(1)
		e3:SetCondition(c19016.negcon)
		e3:SetTarget(c19016.negtg)
		e3:SetOperation(c19016.negop)
		c:RegisterEffect(e3)

end


		function c19016.cfilter(c,atk)
	return	c:IsFaceup()  and  c:GetAttack() > atk
end


function c19016.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then
	local atk = e:GetHandler():GetAttack()
		return	eg:IsExists(c19016.cfilter,1,nil,atk)
			end
				end


						function c19016.operation(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetHandler()
								if c:IsFaceup() and c:IsRelateToEffect(e) then
							local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end


function c19016.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
			and re:IsActiveType(TYPE_MONSTER)
				and re:GetHandler():GetAttack()<=e:GetHandler():GetAttack()
					and Duel.IsChainNegatable(ev)
						end


						function c19016.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
				Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
			if re:GetHandler():IsAbleToHand() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end


function c19016.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			if Duel.SendtoHand(eg,1-tp,REASON_EFFECT)>0 then
				Duel.Damage(1-tp,800,REASON_EFFECT)
			end
		end

end

