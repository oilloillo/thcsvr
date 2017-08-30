 
--逆弓「天壤梦弓」
function c29040.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(c29040.target)
	e1:SetOperation(c29040.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29040.handcon)
	c:RegisterEffect(e2)
end
function c29040.filter(c,e,tp)
	return c:IsSetCard(0x260) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return ep~=tp and (rc:GetType()==TYPE_SPELL+TYPE_TOKEN or rc:GetType()==TYPE_SPELL or rc:GetType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29040.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c29040.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c29040.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c29040.repop)
	end
end
function c29040.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave(false)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c29040.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(29030)
end
function c29040.handcon(e)
	return Duel.GetMatchingGroupCount(c29040.cfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil)>0
end
