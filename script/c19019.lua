--非想非非想绯之衣✿魂魄妖梦
function c19019.initial_effect(c)

		--fusion material
		c:EnableReviveLimit()
		Fus.AddFusionProcFunMulti(c,true,aux.FilterBoolFunction(Card.IsSetCard,0x713),aux.FilterBoolFunction(Card.IsSetCard,0x226),aux.FilterBoolFunction(Card.IsSetCard,0x190))

			--multi attack
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(1)
			c:RegisterEffect(e2)

				--indestructable
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
				e3:SetCountLimit(1)
				e3:SetValue(1)
				c:RegisterEffect(e3)

			--reflect battle dam
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
			e4:SetValue(1)
			c:RegisterEffect(e4)

		--special summon
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(19019,0))
		e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e5:SetCode(EVENT_TO_GRAVE)
		e5:SetCountLimit(1,19019)
		e5:SetCondition(c19019.condition)
		e5:SetTarget(c19019.target)
		e5:SetOperation(c19019.operation)
		c:RegisterEffect(e5)

end
function c19019.condition(e,tp,eg,ep,ev,re,r,rp)
	local pl=e:GetHandler():GetPreviousLocation()
		return bit.band(pl,LOCATION_ONFIELD)~=0
			end


				function c19019.target(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end


function c19019.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UPDATE_ATTACK)
							e1:SetValue(-500)
								e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
									c:RegisterEffect(e1)
									local e2=Effect.CreateEffect(c)
								e2:SetType(EFFECT_TYPE_SINGLE)
							e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
						e2:SetRange(LOCATION_MZONE)
					e2:SetCode(EFFECT_IMMUNE_EFFECT)
				e2:SetValue(c19019.efilter)
			e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
	end
end


function c19019.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

