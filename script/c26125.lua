--有时像虎有时似鸟的家伙✿封兽鵺
--script by Nanahira
function c26125.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26125)
	e1:SetTarget(c26125.sptg)
	e1:SetOperation(c26125.spop)
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
function c26125.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x208) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and #c.hana_mat==2 and m:IsExists(Fus.CheckMaterialSingle,1,e:GetHandler(),c) and e:GetHandler():IsCanBeFusionMaterial(c)
end
function c26125.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Fus.GetFusionMaterial(tp,LOCATION_HAND,nil,nil,c)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c26125.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26125.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Fus.GetFusionMaterial(tp,LOCATION_HAND,nil,nil,c,e)
	local sg1=Duel.GetMatchingGroup(c26125.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg1:GetCount()>0 then
		local sg=sg1:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local mat1=mg1:FilterSelect(tp,Fus.CheckMaterialSingle,1,1,c,tc)
		mat1:AddCard(c)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-800)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc:CompleteProcedure()
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
