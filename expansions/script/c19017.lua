--恋的迷路✿芙兰朵露
function c19017.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x815),aux.FilterBoolFunction(Card.IsSetCard,0x514a),true)

		--cannot be target
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		c:RegisterEffect(e1)

		--to deck
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(19017,0))
		e2:SetCategory(CATEGORY_TODECK)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c19017.target)
		e2:SetOperation(c19017.operation)
		c:RegisterEffect(e2)

end


function c19017.filter(c)
	return c:IsAbleToDeckAsCost()
		end


			function c19017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19017.filter(chkc) end
					if chk==0 then return Duel.IsExistingTarget(c19017.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectTarget(tp,c19017.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end


function c19017.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
			local tc=Duel.GetFirstTarget()
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
					if not tc:IsLocation(LOCATION_DECK) then return end
						Duel.ShuffleDeck(tc:GetControler())
							tc:ReverseInDeck()
								local e1=Effect.CreateEffect(c)
									e1:SetDescription(aux.Stringid(19017,1))
								e1:SetCategory(CATEGORY_DESTROY)
							e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
						e1:SetCode(EVENT_TO_HAND)
					e1:SetTarget(c19017.destg)
				e1:SetOperation(c19017.desop)
			e1:SetReset(RESET_EVENT+0x1de0000)
		tc:RegisterEffect(e1)
	end


function c19017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
			if g:GetCount()>0 then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
		end
	end


function c19017.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end

end
