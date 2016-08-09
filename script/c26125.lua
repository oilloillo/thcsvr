--有时像虎有时似鸟的家伙✿封兽鵺
function c26125.initial_effect(c)

		--send to grave
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26125,0))
		e1:SetCategory(CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetTarget(c26125.tgtg)
		e1:SetOperation(c26125.tgop)
		c:RegisterEffect(e1)
			--search
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(26125,1))
			e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_BE_BATTLE_TARGET)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTarget(c26125.target)
			e2:SetOperation(c26125.operation)
			c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_BECOME_TARGET)
		e3:SetCondition(c26125.condition)
		c:RegisterEffect(e3)

end


function c26125.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208) and c:IsAbleToGrave() and c:IsLevelBelow(4)
end


function c26125.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26125.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end


function c26125.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26125.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
		if tc then
			local code=tc:GetOriginalCode()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end


function c26125.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetLocation()==LOCATION_MZONE
end


function c26125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end


function c26125.filter(c)
	return c:IsSetCard(0x251c) and c:IsAbleToHand()
end


function c26125.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26125.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

