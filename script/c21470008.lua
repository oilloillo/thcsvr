 
--妖魔书-死灵之书
function c21470008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21470008+EFFECT_COUNT_CODE_OATH)
--	e1:SetCost(c21470008.cost)
	e1:SetCondition(c21470008.condition)
	e1:SetTarget(c21470008.target)
	e1:SetOperation(c21470008.activate)
	c:RegisterEffect(e1)
end
function c21470008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21470008)<=0 end
	Duel.RegisterFlagEffect(tp,21470008,RESET_PHASE+PHASE_END,0,1)
end
function c21470008.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN)
end
function c21470008.filter(c,e,tp)
	return c:IsSetCard(0x742) and not c:IsCode(21470008) and
	((c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENCE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) 
	or (c:IsSSetable() and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1))
end
function c21470008.filter2(c,e,tp)
	return c:IsSetCard(0x742) and not c:IsCode(21470008) and
	((c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENCE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) 
	or (c:IsSSetable() and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0))
end
function c21470008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21470008.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c21470008.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c21470008.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0) end
end
function c21470008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_MONSTER) then	
			if c21470008.filter2(tc,e,tp) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENCE) end
		else 
			if c21470008.filter2(tc,e,tp) then 
--				Duel.SendtoHand(tc,tp,REASON_EFFECT)
--				if tc:IsSSetable() then 
					Duel.SSet(tp,tc) 
					Duel.BreakEffect()
					if tc:IsType(TYPE_TRAP) then
						local e3=Effect.CreateEffect(e:GetHandler())
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						tc:RegisterEffect(e3)
					else
						if tc:IsType(TYPE_QUICKPLAY) then tc:SetStatus(STATUS_SET_TURN,false) end
					end
					tc:RegisterFlagEffect(21470008,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
					--[[
					local te=tc:GetActivateEffect()
					local tep=tc:GetControler()
					if not te then
						Duel.SendtoGrave(tc,REASON_EFFECT)
					else
						local condition=te:GetCondition()
						local cost=te:GetCost()
						local target=te:GetTarget()
						local operation=te:GetOperation()
						if te:GetCode()==EVENT_FREE_CHAIN
							and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
							and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
							and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
							Duel.ClearTargetCard()
							e:SetProperty(te:GetProperty())
							Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
							Duel.ChangePosition(tc,POS_FACEUP)
							if not tc:IsType(TYPE_CONTINUOUS) then tc:CancelToGrave(false) end
							tc:CreateEffectRelation(te)
							if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
							if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
							local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
							local tg=g:GetFirst()
							while tg do
								tg:CreateEffectRelation(te)
								tg=g:GetNext()
							end
							if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
							tc:ReleaseEffectRelation(te)
							tg=g:GetFirst()
							while tg do
								tg:ReleaseEffectRelation(te)
								tg=g:GetNext()
							end
						else
							Duel.SendtoGrave(tc,REASON_EFFECT)
						end
					end]]
--				else Duel.SendtoGrave(tc,REASON_EFFECT) end
			end
		end
	end
	c:CancelToGrave()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end